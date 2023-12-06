all: io.asm matrix-testbench.asm my_LINCOMB_COL.asm my_SUM_COL.asm my_PROD_COL.asm my_LINCOMB_ROW.asm my_SUM_ROW.asm my_PROD_ROW.asm
	nasm -felf64 io.asm -o io.o
	nasm -felf64 matrix-testbench.asm -o matrix-testbench.o
	nasm -felf64 my_LINCOMB_COL.asm -o my_LINCOMB_COL.o
	nasm -felf64 my_SUM_COL.asm -o my_SUM_COL.o
	nasm -felf64 my_PROD_COL.asm -o my_PROD_COL.o
	nasm -felf64 my_LINCOMB_ROW.asm -o my_LINCOMB_ROW.o
	nasm -felf64 my_SUM_ROW.asm -o my_SUM_ROW.o
	nasm -felf64 my_PROD_ROW.asm -o my_PROD_ROW.o
	gcc -no-pie -g io.o my_PROD_COL.o my_SUM_COL.o my_LINCOMB_COL.o matrix-testbench.o -o main1
	gcc -no-pie -g io.o my_PROD_ROW.o my_SUM_ROW.o my_LINCOMB_ROW.o matrix-testbench.o -o main2
	python3 autograder.py
	./main1 < test.txt > out.txt
	python3 temp.py
	diff -Bw temp2.txt temp.txt
	rm temp2.txt out.txt
	./main2 < test.txt > out.txt
	python3 temp.py
	diff -Bw temp2.txt temp.txt
	rm *.txt
	rm *.o
