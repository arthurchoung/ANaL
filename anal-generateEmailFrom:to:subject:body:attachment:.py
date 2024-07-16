#!/usr/bin/python3

import os
import sys

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.application import MIMEApplication

def get_attachment(path):
    str = path.lower()
    name = os.path.basename(path)

    data = open(path, 'rb').read()

    part = None
    if str.endswith('.jpg') or str.endswith('.jpeg'):
        part = MIMEImage(data, 'jpeg')
    elif str.endswith('.png'):
        part = MIMEImage(data, 'png')
    elif str.endswith('.gif'):
        part = MIMEImage(data, 'gif')
    elif str.endswith('.txt'):
        part = MIMEText(data, 'plain')
#    elif str.endswith('.html'):
#        part = MIMEText(data, 'html')
    elif str.endswith('.pdf'):
        part = MIMEApplication(data, 'pdf')
    else:
        part = MIMEApplication(data, 'octet-stream')

    part.add_header('Content-Disposition', 'attachment', filename=name)
    return part


if __name__ == "__main__":
    if len(sys.argv) < 5:
        sys.stderr.write("specify from, to, subject, body, attachment\n")
        sys.exit(1)
    fromaddress = sys.argv[1]
    toaddress = sys.argv[2]
    subject = sys.argv[3]
    body = sys.argv[4]

    message = MIMEMultipart()
    message['From'] = fromaddress
    message['To'] = toaddress
    message['Subject'] = subject
    text = MIMEText(body)
    message.attach(text)

    for attachmentfile in sys.argv[5:]:
        attachment = get_attachment(attachmentfile)
        message.attach(attachment)

    print(message.as_string())

