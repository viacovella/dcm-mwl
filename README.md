# dcm-mwl
DICOM modality worklist using only dcm4che tools

## Usage
Start by building the Dockerfile
```bash
docker build -t dicom-lab .
```
then run the container
```bash
# Linux / Mac / PowerShell
docker run -it --rm -p 11112:11112 -v "${PWD}:/workspace" dicom-lab

# Windows CMD
docker run -it --rm -p 11112:11112 -v "%cd%:/workspace" dicom-lab
```
if this does not work, put the full explicit path instead of the variable.

* Once in the container, check whether your local directory was correctly mounted
```bash
ls -l  # you should see your local files
```
## DICOM Worklist construction

* Create the worklist file by converting a xml into a DICOM file
```bash
xml2dcm -x worklist.xml -o output.wl
```
## Index the file using dcmdir
```bash
mkdir -p mwl_storage
cp output.wl mwl_storage/
dcmdir -c mwl_storage/DICOMDIR mwl_storage/output.wl
```
## Run a lightweight DICOM Server using dcmqrscp
```bash
dcmqrscp -b DCM4CHE:11112 --dicomdir mwl_storage/DICOMDIR
```

## Querying (SCU)
* open another instance of the container and try to run the following command
```bash
findscu -c DCM4CHE@localhost:11112 -M MWL
```
