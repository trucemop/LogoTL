#Image Preprocessing
echo '####### Start Image Preprocessing #######'

#Create New Dirs
mkdir -p ./Images/test/pickle/
mkdir -p ./Images/train/pickle/
mkdir -p ./Images/test/DA
mkdir -p ./Images/train/DA

##Convert XML Labels to CSV
echo '####### Convert XML Labels to CSV #######'

# From Home Directory

python ./scripts/xml_to_csv.py -i ./Images/train -o ./annotations/train_labels.csv
python ./scripts/xml_to_csv.py -i ./Images/test -o ./annotations/test_labels.csv

#Data Augmentation - Create Synthetic Training Images
echo '####### Data Augmentation - Create Synthetic Training Images #######'

#Training Set
python3 ./scripts/transformImages.py \
    --input_dir=./Images/train/ \
    --numIters=100 \
    --image_label_file=./annotations/train_labels.csv \
    --output_path=./annotations/train_labels_DA.csv \
    --label0=b52

#Test Set
python3 ./scripts/transformImages.py \
    --input_dir=./Images/test/ \
    --numIters=100 \
    --image_label_file=./annotations/test_labels.csv \
    --output_path=./annotations/test_labels_DA.csv \
    --label0=b52

##Convert CSV to TF-Record
echo '####### Convert CSV to TF-Record #######'


#Post Data Augmentation - Training Set
python3 ./scripts/generate_tfrecord.py \
--csv_input=./annotations/train_labels_DA.csv \
--img_path=./Images/train/DA  \
--output_path=./annotations/train_DA.record \
--label0=b52

#Post Data Augmentation - Test Set
python3 ./scripts/generate_tfrecord.py \
--csv_input=./annotations/test_labels_DA.csv \
--img_path=./Images/test/DA  \
--output_path=./annotations/test_DA.record \
--label0=b52
