---
layout: post
title: Become a mesh!
description: 
summary: 
comments: true
tags: [gmsh, python]
categories: blog
toc: true
last-update: 2023-09-09
---

Besides all its power to generate high quality mesh, [Gmsh](gmsh.info/) also can be used to generate high quality mesh of yours!

![Mesh from picture](/assets/img/pictureMesh.svg "My mesh")

To generate a *mesh* like this one, all you will need is `python` and [`gmsh`](gmsh.info/). In its [webpage](gmsh.info/) you will find all instructions to install it. The following `.geo` file is the script to perform all tasks in [`gmsh`](gmsh.info/). You can download this file [here](/assets/python/pictureToMesh.geo).

```c++
// pictureToMesh.geo

/* ====================================
   Credits to Prof. Christophe Geuzaine
   ==================================== */

If(PostProcessing.NbViews == 0)

  // Merge the image (this will create a new post-processing view, View[0]), and
  // modify the normalized pixel values (v0) to make them reasonnable
  // characteristic lengths for the mesh

  // Input image
  Merge "inputFile.png";

  // Mesh variation
  Plugin(ModifyComponents).Expression0 = "1 + v0^2 * 10";
  Plugin(ModifyComponents).Run;

EndIf

// Apply the view as the current background mesh
Background Mesh View[0];

// Build a simple geometry on top of the background mesh
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

outfile = StrCat(CurrentDirectory, "pic_to_mesh_out.png");

DefineConstant[
  algo = {Mesh.Algorithm, AutoCheck 0, GmshOption "Mesh.Algorithm",
    Choices{1="MeshAdapt", 5="Delaunay", 6="Frontal", 8="DelQuad"},
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
Solver.AutoMesh = 2;
```

Place the picture you want to mesh in the same directory of `pictureToMesh.geo` and name it `inputFile.png`. Open a terminal and run the following command:

```bash
gmsh pictureToMesh.geo
```
After running the command, you will see the Gmsh GUI as below (not in dark mode, if it is have not previously changed):

![Mesh from picture](/assets/img/gmshGui.png "Gmsh GUI")

Firstly, press `Alt + P` and `Alt + L` to hide geometry's points and curves. In the left side bar menu, you can select the meshing options `Algorithm`, `Element size factor`, and `Minimum element size`. Choose these parameters according to your preference (or left them as default values) and press `Run` on the bottom to generate the mesh. To outline the mesh elements, press `Alt + E`. To save, press `Save PNG`. A file named `outputFile.png` will be saved same in the same directory.

![Mesh from picture](/assets/img/gmshGuiMesh.png "Your mesh")

Besides the saved picture, a mesh file called `pictureToMesh.msh` will also be saved. This is the mesh file generated from your picture discretization based on pixel variations. You can open this file with gmsh as well

```bash
gmsh pictureToMesh.msh
```

![Mesh from picture](/assets/img/gmshGuiMeshMshFormat.png "Msh format")
