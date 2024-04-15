#!/bin/bash

# Checks if AWS CLI config file is set
check_aws_config_and_cred() {
    if [ -f ~/.aws/config ] && [ -f ~/.aws/credentials ]; 
    then
        echo "AWS CLI configuration is already set."
    else
        echo "AWS CLI configuration is not set."
        aws_config_set
    fi
}


# Checks if the file exists or not. Will terminate program if it doesn't
check_file () {
    local file_name="$1"
    if [ ! -e "$file_name" ]; then
    echo "File '$file_name' not found. Please pass a valid file path as a argument. Exiting script."
    exit 1 
    else
        echo "File '$file_name' does exist."
    
    fi
}

# Sets AWS config & creds file if not already configured
aws_config_set() {
echo "Enter AWS acccess key ID:"
read aws_access_key_id

echo "Enter AWS secret access key:"
read secret_access_key

echo "Enter AWS default region:"
read default_region

echo "Enter AWS default output:"
read default_output

# Setting these as environment variables to make them persistent 
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY_ID=$secret_access_key
export AWS_DEFAULT_REGION=$default_region
export AWS_DEFAULT_OUTPUT=$default_output


aws configure set aws_access_key_id "$aws_access_key_id"
aws configure set aws_secret_access_key "$secret_access_key"
aws configure set region "$default_region"
aws configure set output "$default_output"
}

# Sends data to S3. Will overwrite data if filename is the same
send_to_s3() {
    echo "What is your bucket's name?"
    read bucket_name
    aws s3 cp $1 s3://$bucket_name/
    if [ $? -eq 0 ]; 
    then
        echo "Copy successful."
    else
        echo "Copy failed."
    fi  
}

check_file "$1"
check_aws_config_and_cred
send_to_s3 "$1"

