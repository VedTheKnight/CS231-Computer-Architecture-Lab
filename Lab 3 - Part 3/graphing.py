import matplotlib.pyplot as plt
x = [128,256,512,1024,2048]
tsc = 3193909000 
y_col = [1872819/tsc , 12698332/tsc , 91130203/tsc , 361387347/tsc , 1058747324/tsc ] 
y_row = [688734/tsc, 1161392/tsc, 4637745/tsc, 20527734/tsc, 79654577/tsc] 

print(y_col)
print(y_row)

plt.plot(x, y_col, label='column', color='blue')
plt.plot(x, y_row, label='row', color='red')

plt.xlabel('Size of Matrix')
plt.ylabel('Time')
plt.title('Relation between size of matrix and time for row and column traversal')
plt.legend()

plt.show()