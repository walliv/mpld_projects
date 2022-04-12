FID = fopen ('../FIR_data/FIR_data_in.txt');
FIR_in = fscanf(FID,'%d');
fclose(FID);

FID = fopen ('../FIR_data/FIR_data_out.txt');
FIR_out = fscanf(FID,'%d');
fclose(FID);


subplot(2,1,1)
plot(FIR_in,'b','linewidth',2);

subplot(2,1,2)
plot(FIR_out,'g','linewidth',2);
