LoadFaces[n_] := ColorConvert[ Import /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], "testfaces", "*.jpg"}]], n], "Grayscale"]

LoadImages[n_, directory_, type_] := ColorConvert[ Import /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], directory, "*." <> type}]], n], "Grayscale"]

LoadRgbImages[n_, directory_, type_] := Import /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], directory, "*." <> type}]], n]

FlattenImage[image:(_Graphics | _Image)]:=N[Flatten[ImageData[ImageResize[image, {70, 70}]]]];

FlattenRgbImage[image_] := N /@ (Flatten /@ (ImageData /@ (ImageResize[#, 70]& /@ (ColorSeparate[image]))))

EigenFaces[faces_, ncomps_] := 
 Module[{imgMatrix, avg},
    imgMatrix = FlattenImage /@ faces;
    avg  = N[Total[imgMatrix]]/Length[imgMatrix];
    Eigenvectors[Covariance[imgMatrix], ncomps]
]

RgbEigenFaces[faces_, ncomps_] :=
    Module[{imgMatrices, avgs},
    imgMatrices = Transpose[FlattenRgbImage /@ faces];
    avgs = N /@ (Total /@ imgMatrices) / (Length /@ imgMatrices);
    Function[x, Eigenvectors[Covariance[x], ncomps] /@ imgMatrices
]

(*  UnflattenRgbFace[faceR_, faceG_, faceB_] *)

FormatFace[face_] := Graphics[Raster[Partition[Reverse[face], 70]]]
