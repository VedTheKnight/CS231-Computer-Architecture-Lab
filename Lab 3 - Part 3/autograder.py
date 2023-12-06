import numpy as np
#Input
n = int(input("Enter the size N : "))
#Scalars
x1 = np.random.randint(-50,50)
x2 = np.random.randint(-50,50)
x3 = np.random.randint(-50,50)
x4 = np.random.randint(-50,50)


#Arrays
arr1 = np.random.randint(-75,75,(n,n))
arr2 = np.random.randint(-75,75,(n,n))
arr3 = np.random.randint(-75,75,(n,n))
arr4 = np.random.randint(-75,75,(n,n))


#Writing to file
f = open("test.txt", "w")
f.write(str(n))
f.write("\n")
f.write(str(x1))
f.write("\n")
f.write(str(x2))
f.write("\n")
f.write(str(x3))
f.write("\n")
f.write(str(x4))
f.write("\n")
for i in arr1:
    for x in i:
        f.write(str(x))
        f.write("\n")
for i in arr2:
    for x in i:
        f.write(str(x))
        f.write("\n")
for i in arr3:
    for x in i:
        f.write(str(x))
        f.write("\n")
for i in arr4:
    for x in i:
        f.write(str(x))
        f.write("\n")
f.close()

#Now getting the correct output
b1 = x1*arr1 + x2*arr2
b2 = x3*arr3 + x4*arr4
b = b1*b2
sum = 0
for i in range(n):
    for j in range(n):
        if((i+j)%2==0):
            sum += b[i][j]
        else:
            sum -= b[i][j]
print("Your correct output should be", sum)
f2 = open("temp.txt", "w")
f2.write(str(sum))
f2.close()
