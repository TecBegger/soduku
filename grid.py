from tkinter import *
from tkinter import ttk

class grid :
    
    selected = 0

    def __init__(self, root,row,colum) :
      self.viewroot = root
      self.view = ttk.Button(root,text="N", command=self.onClick, width = 100) 
      self.available = []
      for i in range(0,row*colum) :
          self.available.append(i)

      self.choosen = 0
      

    def  getLabel(self):
        label = StringVar()
        if self.choosen == 0 :
            count = 0
            for i in self.available:
                count += 1
                if i == 0 :
                    label.append(' ')
                else :
                    label.append(str(i))
                if count%3 == 0 :
                    label.append('\n')
        else :
            label.append(str(self.choosen))
        
        return label
    
    def onClick(self) :
        if self.selected == 0 :
            self.selected = 1
        else :
            self.selected = 0
