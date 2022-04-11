function ABC_concatenate(ISO,numrun)
  
currentFolder = pwd;
myFolder = [currentFolder,'/ABC_outputs_lastgen/',ISO];
%         if not(isfolder(myFolder))
%             mkdir(myFolder)
%         end
        
      filePattern = fullfile(myFolder, '*_lastGen.mat');
      matFiles = dir(filePattern);
      for i = 1:length(matFiles)
          baseFileName = fullfile(myFolder, matFiles(i).name);
          matData(i)=load(baseFileName);
      end
      newABC=vertcat(matData(1:numrun).ABC_lastGen);
      subdir= ['/RUNS',num2str(numrun)];
      
%       dir2 = ['ABC_outputs_combined/',ISO,'/',subdir];
%         if not(isfolder(dir2))
%             mkdir(dir2)
%         end
          
      dir3 = ['ABC_outputs_combined/',ISO,];
        if not(isfolder(dir3))
            mkdir(dir3)
        end
      filename = [dir3,'/ABC.',num2str(numrun),'.mat'];

      save(filename, 'newABC')
      
      clear
end
