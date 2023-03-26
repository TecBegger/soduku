from tkinter import *
from tkinter import ttk
from grid import *

class soduku :

    def __init__(self, root,row,colum):

        self.row = row
        self.collum = colum

        self.frame = ttk.Frame(root,borderwidth = 2,relief="ridge", width=300, height=300)

        ## create one soduku
        for i in range(0,row) :
            for j in range(0,colum) :
                #iter = grid(self.frame,row,colum)
                #iter.grid(colum = j,row = i)
                #self.mylist[i][j] = iter
                pass

    def grid(self,colum ,row ,columspan,rowspan):
        self.frame.grid(column=colum,row=row,columnspan=columspan,rowspan=rowspan)

