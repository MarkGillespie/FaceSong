LoadMusic[n_, type : "mid"] := Import /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], "testmusic", "*" <> type}]], n]

LoadWav[n_] := Import[#, "SampledSoundList"] & /@ Take[FileNames[FileNameJoin[{NotebookDirectory[], "testmusic", "*.wav"}]], n]

SampleAround[samples_, index_, width_] :=
    Module[ {minVal, maxVal},
        minVal = Max[1, index - width];
        maxVal = Min[Length[samples], index + width];
        samples[[minVal;;maxVal]]
    ]

DftAt[samples_List, index_, width_] := 
    Module[ {doubleFft},
        doubleFft = Re /@ Fourier[SampleAround[samples, index, width]];
        Take[doubleFft, Floor[Length[doubleFft]/2]]
    ]
