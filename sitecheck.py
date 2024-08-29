#! /usr/bin/env python3

import smtplib
import subprocess
import requests
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Configuration
urls = [
    "https://strangeworld.blog",
    "https://git.strangeworld.blog",
    "https://serve.strangeworld.blog/",
]

# Configuration
sender_email = "anantkumar212204@gmail.com"
receiver_email = "anantkumar212204@gmail.com"
password = "lujr dmfa cnqb jybd"
smtp_server = "smtp.gmail.com"
smtp_port = 587

def check_websites():
    down_sites = []
    
    for url in urls:
        try:
            response = requests.get(url)
            if response.status_code != 200:
                down_sites.append(f"{url} returned status code: {response.status_code}")
        except requests.exceptions.RequestException as e:
            down_sites.append(f"Error accessing {url}: {e}")
    
    if down_sites:
        message = "\n".join(down_sites)
        send_email(message)
        send_notification(message)

def send_email(message):
    # Create the email content
    subject = "Website Status Alert"
    body = f"The following issues were detected:\n\n{message}"
    
    # Setup the MIME
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))
    
    try:
        # Connect to the Gmail SMTP server and send email
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()  # Secure the connection
        server.login(sender_email, password)
        text = msg.as_string()
        server.sendmail(sender_email, receiver_email, text)
        server.quit()
        print("Alert email sent successfully!")
    except Exception as e:
        print(f"Failed to send email: {e}")

def send_notification(message):
    # Send a desktop notification using notify-send
    try:
        subprocess.run(["notify-send", "-u critical","Website Status Alert", message])
        print("Desktop notification sent!")
    except Exception as e:
        print(f"Failed to send desktop notification: {e}")

if __name__ == "__main__":
    # check_websites()
    send_email("testing u idiot")


