f = open("out.txt", "r")
f2 = open("temp2.txt", "w")
count=0
for line in f.readlines():
	if(count==1):
		count+=1
		print("Cycle counts :", line)
	if(count==0):
		count+=1
		f2.write(line)
f2.close()
f.close()
