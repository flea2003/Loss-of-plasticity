module load 2023r1
module load miniconda3
conda create -n "lop" python=3.8 ipython
pip3 install -r requirements.txt 
#pip3 install -e .
#pip install --force-reinstall setuptools
