LoadFaces[n_] := With[{nb = EvaluationNotebook[]}, Import /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], "testfaces", "*.jpg"}]], n]]

FlattenImage[image:(_Graphics | _Image)]:=N[Flatten[ImageData[ImageResize[image,100]]]];

EigenImageElements[images_List, frac_ : 0.5] := 
     Module[{imgMatrix = FlattenImage /@ images, imgMatrixAdj, imgAverage, eigenVecs},
        imgAverage = N[Total[imgMatrix] / Length[imgMatrix]];
        imgMatrixAdj = (# - imgAverage) & /@ imgMatrix;
        eigenVecs = Eigenvectors[
            Dot[
                imgMatrixAdj,
                Transpose[imgMatrixAdj]
            ],
            Ceiling[
                frac*Length[imgMatrixAdj]
            ]
        ];
        imgMatrixAdj = Dot[eigenVecs, imgMatrix];
        {imgMatrixAdj, imgAverage, eigenVecs}
]

