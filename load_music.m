LoadSong[name_] := Import[FileNameJoin[{NotebookDirectory[], "testmusic", 
    name <> ".csv"}], "Data"];
