---
layout: post
title: Become a mesh!
description: 
summary: 
comments: true
tags: [gmsh, python]
categories: blog
toc: true
last-update: 2023-09-13
---

Besides all its power to generate high quality mesh, [Gmsh](https://gmsh.info/) also can be used to generate high quality mesh of yours!

![Mesh from picture](/assets/img/pictureMesh.svg "My mesh")

To generate a mesh like this one, all you will need is `python` and [`gmsh`](https://gmsh.info/). In its [webpage](https://gmsh.info/) you will find all instructions to install it. The following `.py` file is the script to perform all tasks in [`gmsh`](https://gmsh.info/). You can download this file [here](/assets/python/pic2msh.py).

```python
# pic2msh.py

#  ====================================
#  Credits to Prof. Christophe Geuzaine
#  ==================================== 

import sys
import subprocess

# Picture to be meshed
filename = str(sys.argv[1])
filename = f'"{filename}"'

# Write GEO file as input for Gmsh
header = f'If(PostProcessing.NbViews == 0) \n \
\t Merge {filename}; \n\
\t Plugin(ModifyComponents).Expression0 = "1 + v0^3 * 10"; \n\
\t Plugin(ModifyComponents).Run; \n\
EndIf\n'

body = """
Background Mesh View[0];
w = View[0].MaxX;
h = View[0].MaxY;

Point(1)={0,0,0,w};
Point(2)={w,0,0,w};
Point(3)={w,h,0,w};
Point(4)={0,h,0,w};
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};
Line Loop(5) = {3,4,1,2};
Plane Surface(6) = {5};

DefineConstant[
  algo = {Mesh.Algorithm, AutoCheck 0, GmshOption "Mesh.Algorithm",
    Choices{1="MeshAdapt", 2="Automatic", 5="Delaunay", 6="Frontal-Delaunay", 
    7="BAMG", 8="Frontal-Delaunay for Quads", 9="Packing of Parallelograms",
    11="Quasi-structured Quad"},
    Name "Meshing parameters/Algorithm"},

  sizeFact = {Mesh.CharacteristicLengthFactor, AutoCheck 0,
    GmshOption "Mesh.CharacteristicLengthFactor", Min 0.1, Max 10, Step 0.1,
    Name "Meshing parameters/Element size factor"},

  sizeMin = {Mesh.CharacteristicLengthMin, AutoCheck 0,
    GmshOption "Mesh.CharacteristicLengthMin", Min w/100, Max w, Step 0.1,
    Name "Meshing parameters/Minimum element size"},

  save = {StrCat("View.ShowScale=0;Print '", CurrentDirectory, "outputFile.png';"),
    AutoCheck 0, Macro "GmshParseString",
    Name "Save PNG"}
];

Mesh.ColorCarousel = 0;
Mesh.Color.Triangles = Black;
Mesh.Color.Quadrangles = Black;
Mesh.RecombineAll = (algo == 8);
Solver.AutoMesh = 2;"""

geoFile = header + body

def write_input():
    f = open('input.geo', "w")
    f.write(geoFile)
    f.close()

def run_mesh_gui():
    subprocess.run(["gmsh", "input.geo"])
    subprocess.run(["gmsh", "input.msh"])

# Run
write_input()
run_mesh_gui()
```

To obtain an expected results, it is recommended to use a picture with a 'plain background'. To remove the background from any picture, I recommend [this](https://www.remove.bg/) website. In addition to removing the background, it is important to set a plain color background, preferably white. After tweaking the input picture, open a terminal and run the following command:

```bash
python pic2mesh.py path_to_picture
```

After running the command, you will see the Gmsh GUI as below (not in dark mode, if it is have not previously changed):

![Mesh from picture](/assets/img/gmshGui.png "Gmsh GUI")

Firstly, press `Alt + P` and `Alt + L` to hide geometry's points and curves. In the left side bar menu, you can select the meshing options `Algorithm`, `Element size factor`, and `Minimum element size`. Choose these parameters according to your preference (or left them as default values) and press `Run` on the bottom to generate the mesh. To outline the mesh elements, press `Alt + E`. To save, press `Save PNG`. A file named `outputFile.png` will be saved same in the same directory.

![Mesh from picture](/assets/img/gmshGuiMesh.png "Your mesh")

Besides the saved picture, a mesh file named `pictureToMesh.msh` will also be saved. This mesh file is generated from your picture's discretization based on pixel variations. When you close the Gmsh GUI that is currently open, a new GUI will appear, displaying only the generated mesh:

![Mesh from picture](/assets/img/gmshGuiMeshMshFormat.png "Msh format")

Now you can have a better visualization of the mesh. If it presents the expected result, you can export it in a vector graphics format, such as SVG or PDF. Using the top menu, go to `File > Export` and select you preferred file format. For tweaking the vector image, I do recommend using [Inkscape](https://inkscape.org/), for instance. From now on, your creativity is what matters most.

Good meshing!
