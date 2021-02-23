function [fileNames, filePath] = loadNames(path, string)

    filelist = dir(fullfile(path, strcat('**\', string)));
    fileNames = {filelist.name};
    filePath = {filelist.folder};
