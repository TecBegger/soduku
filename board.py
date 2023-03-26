from tkinter import *
from tkinter import ttk
from soduku import *

class board :

    def __init__(self, root,row,colum):
        root.title("Soduku")

        self.row = row
        self.collum = colum

        self.sodukus = []

        ## create the soduku
        for i in range(0,row) :
            for j in range(0,colum) :
                iter = soduku(root,row,colum)
                iter.grid(colum = j*colum,row = i*row,columspan = colum,rowspan = row)
                self.sodukus.append(iter)
