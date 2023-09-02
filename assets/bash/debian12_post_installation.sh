#!/bin/bash

start=`date +%s`

echo "

===============================================================================
                          DEBIAN 12 POST INSTALLATION

DIEGO MAGELA LEMOS
diegomagela@usp.br
===============================================================================

"

# Firstly, one should add the $USER to sudoers
echo "

Adding $USER to sudoers...
Enter root password

"

su -c '
echo "
# Adding $USER to sudoers
$USER ALL=(ALL:ALL) ALL
" | tee -a /etc/sudoers > /dev/null'

echo "

Completed!

"


# Update the system
echo "

Updating the system...

"
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

echo "

Completed!

"

# Install some packages
echo "

Installing packages...

"

sudo apt install bash-completion vim wget curl btop htop git \
     build-essential gfortran cmake gdb gnome-console geary docker.io \
     gnuplot ruby-dev timeshift inkscape gimp -y
sudo apt remove gnome-terminal -y && sudo apt autoremove -y

# Enable fingerprint login (Gnome)
sudo apt install fprintd libpam-fprintd -y

echo "

Completed!

"

# Install flatpak
echo "

Installing flatpak...

"

sudo apt install flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# Customizing grub 
echo "

Customizing grub...

"

# Remove grub wallpaper
echo '
# Remove grub wallpaper
GRUB_BACKGROUND=""

# Remove grub splash image
GRUB_CMDLINE_LINUX_DEFAULT=""
' | sudo tee -a /etc/default/grub > /dev/null

# Change grub colors
echo 'set color_normal=light-gray/black
set menu_color_normal=white/black
set menu_color_highlight=black/light-gray"' \
| sudo tee /boot/grub/custom.cfg > /dev/null

# Update grub
sudo update-grub

echo "

Completed!

"

# Remove desktop wallpaper
echo "

Removing background...

"

gsettings set org.gnome.desktop.background picture-uri ""
gsettings set org.gnome.desktop.background picture-uri-dark ""
gsettings set org.gnome.desktop.background primary-color black

echo "

Completed!

"

# Install C/C++ packages
echo "

Installing C/C++ packages...

"
sudo apt install libeigen3-dev libsuitesparse-dev libopenblas-dev -y

echo "

Completed!

"

# Install python packages
echo "

Installing Python packages...

"
sudo apt install ipython3 pipx python3-numpy python3-scipy python3-sympy \
                 python3-matplotlib -y
echo "

Completed!

"

# Create python environment
echo "

Creating Python environment...

"

python_env_dir="$HOME/Desktop/python"
python3 -m venv ${python_env_dir} 
touch requirements.txt
echo 'numpy
scipy
simpy
matplotlib
gmsh
ipython
ipykernel' >> requirements.txt
${python_env_dir}/bin/pip3.11 install -r requirements.txt
rm requirements.txt

touch $HOME/.bash_aliases
echo alias pyenv=\""source ${python_env_dir}/bin/activate"\" \
     | tee -a $HOME/.bash_aliases > /dev/null
eval "source $HOME/.bashrc"

echo "

Completed!

"

# Install VSCode
echo "

Installing Visual Studio Code...

"

sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common apt-transport-https gnupg -y
wget -O- https://packages.microsoft.com/keys/microsoft.asc \
         | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg
echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main \
         | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install code -y
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cmake-tools
code --install-extension james-yu.latex-workshop
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension streetsidesoftware.code-spell-checker-portuguese-brazilian
echo "

Completed!

"

# Install PETSc

echo "

Installing PETSc...

"

petsc_dir="$HOME/Desktop"
git clone -b release https://gitlab.com/petsc/petsc.git ${petsc_dir}/petsc
cd ${petsc_dir}/petsc
git pull
./configure --with-cc=gcc --with-cxx=g++ --with-fc=gfortran --download-mpich \
            --download-fblaslapack
make all check
cd

echo "
### >>> PETSc >>>
export PETSC_DIR=$HOME/Desktop/petsc
export PETSC_ARCH=arch-linux-c-debug
export PATH=$PETSC_DIR/lib/petsc/bin/:\$PATH
### <<< PETSc <<<
" | tee -a $HOME/.bashrc > /dev/null

eval "source $HOME/.bashrc"

echo "

Completed!

"

# Install OpenFOAM (openfoam.com) using docker

echo "

Installing OpenFOAM [openfoam.com] using docker...

"

openfoam_dir="$HOME/Desktop/OpenFOAM"

mkdir ${openfoam_dir}
cd ${openfoam_dir}
wget https://develop.openfoam.com/packaging/containers/-/raw/main/openfoam-docker
chmod +x openfoam-docker
ln -sf openfoam-docker openfoam-default

sudo docker pull opencfd/openfoam-default

echo alias openfoam=\""sudo bash ${openfoam_dir}/openfoam-default"\" \
     | tee -a $HOME/.bash_aliases > /dev/null
eval "source $HOME/.bashrc"

# Add the repository
curl https://dl.openfoam.com/add-debian-repo.sh | sudo bash -y

# Update the repository information
sudo apt-get update

# Install preferred package. Eg,
sudo apt-get install openfoam-default -y


sudo apt install paraview -y

echo "

Completed!

"

# Install Texlive
echo "

Installing Texlive...

"
# ./install_tex_live path_to_iso
sudo apt install texlive-full -y

echo "

Completed!

"

echo "

Updating the system...

"

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

echo "

Completed!

"


echo "

Creating a snapshot (backup) of the system...

"

sudo timeshift --create --comments "Initial setup"

echo "

Completed!

"


echo "

==========================
          FINISH
==========================

"

end=`date +%s`

echo Execution time was `expr $end - $start` seconds | tee $HOME/Documents/log.txt

echo "

Rebooting the system...

"
sleep 5
sudo reboot
