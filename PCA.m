LoadFaces[n_] = Import /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], "testfaces", "*.jpg"}]], n]
