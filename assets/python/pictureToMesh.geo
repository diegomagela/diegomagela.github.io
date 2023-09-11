If(PostProcessing.NbViews == 0)

  // Merge the image (this will create a new post-processing view, View[0]), and
  // modify the normalized pixel values (v0) to make them reasonnable
  // characteristic lengths for the mesh

  // Input image
  Merge "inputFile.png";

  // Mesh variation
  Plugin(ModifyComponents).Expression0 = "1 + v0^3 * 10";
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