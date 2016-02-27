LoadFaces[n_] := ColorConvert[ Import /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], "testfaces", "*.jpg"}]], n], "Grayscale"]

FlattenImage[image:(_Graphics | _Image)]:=N[Flatten[ImageData[ImageResize[image,100]]]];

EigenFaces[faces_, ncomps_] := 
 Module[{imgMatrix, avg},
    imgMatrix = FlattenImage /@ faces;
    avg  = N[Total[imgMatrix]]/Length[imgMatrix];
    Dot[Transpose[imgMatrix], #] & /@ Eigenvectors[Covariance[Transpose[imgMatrix]], ncomps]
]

FormatFace[face_] := Graphics[Raster[Partition[face, 100]]]
