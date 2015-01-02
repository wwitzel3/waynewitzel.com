---
categories: ["python", "code"]
date: "2008-07-16T18:27:55-04:00"
tags: ["python", "code"]
title: 'Saving in memory file to disk with Python'
---
Okay, I discovered this today when looking to increase the speed at which uploaded documents were saved to disk. Now, I can't explain the inner workings of why it is fast(er), all I know is that with the exact same form upload test ran 100 times with a 25MB file over a 100Mbit/s network this method was on average a whole 2.3 seconds faster over traditional methods of write, writelines, etc..

How does this extend to real-world production usage over external networks, well no idea. Though I plan to find out. So you all will be the first to know as soon as I find some guinea pig site that does enough file uploads to implement this on.
```
# Minus some boiler plate for validity and variable setup.
import os
import shutil
memory_file = request.POST['upload']
disk_file = open(os.path.join(save_folder, save_name),'w')
shutil.copyfileobj(memory_file.file, disk_file)
disk_file.close()
```
