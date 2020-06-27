#!/bin/bash

# Download the GLUE data
GLUE_DIR="./glue_data"
if [ ! -d ${GLUE_DIR} ]
then 
    wget "https://gist.githubusercontent.com/W4ngatang/60c2bdb54d156a41194446737ce03e2e/raw/17b8dd0d724281ed7c3b2aeeda662b92809aadd5/download_glue_data.py"
    python3 download_glue_data.py
fi

# Download GloVe
GLOVE_DIR="./glove"
GLOVE_CONF="glove.42B.300d"
GLOVE_EMB="./${GLOVE_DIR}/${GLOVE_CONF}.txt"
if [ ! -d ${GLOVE_DIR} ]
then 
    mkdir -p ${GLOVE_DIR}
    compresed_file="${GLOVE_DIR}/${GLOVE_CONF}.zip"
    wget "http://nlp.stanford.edu/data/${GLOVE_CONF}.zip" -O ${compresed_file}
    unzip ${compresed_file} -d ${GLOVE_DIR}
    rm -rf ${compresed_file}
fi

# Download BERT
BERT_DIR="bert-base-uncased"
if [ ! -d ${BERT_DIR} ]
then
    mkdir -p ${BERT_DIR}
    wget "https://s3.amazonaws.com/models.huggingface.co/bert/bert-base-uncased-vocab.txt" -O "${BERT_DIR}/vocab.txt"
    compresed_file="${BERT_DIR}/bert-base-uncased.tar.gz"
    wget "https://s3.amazonaws.com/models.huggingface.co/bert/bert-base-uncased.tar.gz" -O ${compresed_file}
    tar zxvf ${compresed_file} -C ${BERT_DIR}
    mv "${BERT_DIR}/bert_config.json" "${BERT_DIR}/config.json"
    rm -rf ${compresed_file}
fi

# Data augmetation
TASK_NAME="SST-2"
python3 data_augmentation.py --pretrained_bert_model ${BERT_DIR} --glove_embs ${GLOVE_EMB} --glue_dir ${GLUE_DIR} --task_name ${TASK_NAME}
