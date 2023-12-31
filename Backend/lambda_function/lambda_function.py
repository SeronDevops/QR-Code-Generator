import json
import boto3
import qrcode
from io import BytesIO

def generate_qr_code(url):
    # Generate QR code
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")

    # Save QR code image to BytesIO
    img_bytearray = BytesIO()
    img.save(img_bytearray, format="PNG")
    img_bytearray.seek(0)

    return img_bytearray

def upload_to_s3(bucket_name, key, data):
    # Upload data to S3
    s3 = boto3.client("s3")
    s3.upload_fileobj(data, bucket_name, key)

def lambda_handler(event, context):
    try:
        # Retrieve the URL from the event payload
        payload = json.loads(event["body"])
        url = payload.get("url")

        if not url:
            raise ValueError("URL is missing in the request payload")

        # Generate QR code
        qr_code_data = generate_qr_code(url)

        # Save QR code image to S3
        bucket_name = "your-s3-bucket-name"
        key = f"qr_codes/{context.aws_request_id}.png"
        upload_to_s3(bucket_name, key, qr_code_data)

        # Construct S3 object URL
        s3_object_url = f"https://{bucket_name}.s3.amazonaws.com/{key}"

        # Return S3 object URL in the API response
        response = {
            "statusCode": 200,
            "body": json.dumps({"qr_code_url": s3_object_url}),
        }
    except Exception as e:
        response = {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }

    return response
