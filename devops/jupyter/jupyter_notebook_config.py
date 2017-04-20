from notebook.auth import passwd
import os

def get_pw():
    notebook_pw = os.environ['NOTEBOOK_PASSWORD']
    return passwd(notebook_pw)

c.NotebookApp.password = get_pw()
