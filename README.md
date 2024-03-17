# OpenMAP-T1-V2
**OpenMAP-T1-V2 parcellates the whole brain into 280 anatomical regions based on JHU-atlas in 50 (sec/case).**

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1fmfkxxZjChExnl5cHITYkNYgTu3MZ7Ql#scrollTo=xwZxyL5ewVNF)

## Installation Instructions
0. install python and make virtual environment<br>
python3.9 or later is recommended.

1. Clone this repository, and go into the repository:
```
git clone -b v2.0.0  https://github.com/radiology-code/OpenMAP-T1.git
cd OpenMAP-T1
```
2. Please install PyTorch compatible with your environment.<br>
https://pytorch.org/

Once you select your environment, the required commands will be displayed.

![image](media/PyTorch.png)

If you want to install an older Pytorch environment, you can download it from the link below.<br>
https://pytorch.org/get-started/previous-versions/

4.  Install libraries other than PyTorch:
```
pip install -r requirements.txt
```
5. Please apply and download the pre-trained model from the link below and upload it to your server.

6. You can run OpenMAP-T1 !!

## How to use it
Using OpenMAP-T1 is straightforward. You can use it in any terminal on your linux system. We provide CPU as well as GPU support. Running on GPU is a lot faster though and should always be preferred. Here is a minimalistic example of how you can use OpenMAP-T1.
```
python3 parcellation.py -i INPUT_FOLDER -o OUTPUT_FOLDER -m MODEL_FOLDER
```
If you want to specify the GPU, please add ```CUDA_VISIBLE_DEVICES=N```.
```
CUDA_VISIBLE_DEVICES=1 python3 parcellation.py -i INPUT_FOLDER -o OUTPUT_FOLDER -m MODEL_FOLDER
```

## How to download the pretrained model.
You can get the pretrained model from the this link.
[Link of pretrained model](https://forms.office.com/Pages/ResponsePage.aspx?id=OPSkn-axO0eAP4b4rt8N7Iz6VabmlEBIhG4j3FiMk75UQUxBMkVPTzlIQTQ1UEZJSFY1NURDNzRERC4u)

![image](media/Download_pretrained.png)

## Folder
All images you input must be in NifTi format and have a .nii extension.
```
INPUT_FOLDER/
  ├ A.nii
  ├ B.nii
  ├ *.nii

OUTPUT_FOLDER/
  ├ A/
  |   ├ A.nii # input image
  |   ├ A_volume.csv # volume information (mm^3)
  |   └ A_280.nii # parcellation map
  └ B/
      ├ B.nii
      ├ B_volume.csv
      └ B_280.nii

MODEL_FOLDER/
  ├ CNet/CNet.pth
  ├ SSNet/SSNet.pth
  ├ PNet
  |   ├ coronal.pth
  |   ├ sagittal.pth
  |   └ axial.pth
  └ HNet/
      ├ coronal.pth
      └ axial.pth
```
## Containerization
1. Requirements: install docker if docker image to be built, install docker and install apptainer (https://apptainer.org/docs/admin/main/installation.html) to build apptainer container, install make to run Makefile
2. Copy models files into models/OpenMAP-T1-V2.0.0 folder with the same tree structure as shown in the MODEL_FOLDER above
3. To build docker image, from repository root run:
   ```
   make build-docker
   ```
   Thus openmap-t1 image is built.
5. Docker image usage:
   ```
   docker run --rm -v $INPUT_FOLDER:/input -v $OUTPUT_FOLDER:/output openmap-t1
   ```
   where variables INPUT_FOLDER and OUTPUT_FOLDER are as defined above
7. To build apptainer image, from repository root run:
   ```
   make build-apptainer
   ```
   Thus openmap-t1.sif file is created.
8. Apptainer image usage:
   ```
   apptainer run --nv --writable-tmpfs -B $INPUT_FOLDER:/input -B $OUTPUT_FOLDER:/output openmap-t1.sif
   ```
   where variables INPUT_FOLDER and OUTPUT_FOLDER are as defined above<br>
   Note:<br>
   Use --nv to utilize host's gpu<br>
   The container file system is readonly and the program tries to create a temporary folder named N4 which causes mkdir failure, use --writable-tmpfs to enable writing, there is a size limit of 64M by default https://apptainer.org/docs/user/latest/persistent_overlays.html, change setting when necessary.<br>
   Alternatively make a binding point for the temporary folder, in this case, the N4 folder can't be shared between concurrent instances:
   ```
   apptainer run --nv -B $OPENMAP_INPUT_DIR:/input -B $OPENMAP_OUTPUT_DIR:/output -B /tmp/N4:/openmap/N4 openmap-t1.sif
   ```
## FAQ
* **How much GPU memory do I need to run OpenMAP-T1?** <br>
We ran all our experiments on NVIDIA RTX3090 GPUs with 24 GB memory. For inference you will need less, but since inference in implemented by exploiting the fully convolutional nature of CNNs the amount of memory required depends on your image. Typical image should run with less than 4 GB of GPU memory consumption. If you run into out of memory problems please check the following: 1) Make sure the voxel spacing of your data is correct and 2) Ensure your MRI image only contains the head region.

* **Will you provide the training code as well?** <br>
No. The training code is tightly wound around the data which we cannot make public.
