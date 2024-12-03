# Flipkart Grid 6.0 - Fruit Shelf Life And Product OCR Detection

## Overview

Welcome to the **Fruit Shelf Life Detection** app built for **Flipkart Grid 5.0**! This innovative Flutter application leverages advanced camera vision technology and machine learning to help users seamlessly capture and organize essential details from a wide range of grocery products, specifically fruits.

Our solution goes beyond simple data capture; it intelligently predicts the shelf life of fruits based on their visual attributes, ensuring that users make informed purchasing decisions.

## Key Features

- **Standalone OCR**: Perform Optical Character Recognition (OCR) on-device without relying on server connections, ensuring speed and reliability.
  
- **Image Capture & Preprocessing**: Effortlessly capture images and enhance their quality using advanced preprocessing techniques to improve text extraction accuracy.
  
- **Text Detection & Segmentation**: Utilize contour detection to isolate text and segment it based on font characteristics for more precise data extraction.
  
- **Structured Data Output**: Transfer extracted raw data to our custom LLama3-70b model, which processes it into a well-organized format for easy access and analysis.

## Freshness Index

Our unique freshness index assesses fruit quality by analyzing key attributes such as shape, color, and texture. This sophisticated approach uses transfer learning with the **Efficient Net** algorithm, allowing us to deliver accurate freshness predictions that inform users about the shelf life of their fruits.

## Tech Stack

- **Flutter**: For a responsive and user-friendly mobile app experience
- **ML Kit**: To integrate powerful machine learning functionalities
- **AWS**: For seamless deployment and storage solutions

## Backend Repository

For the backend implementation, visit our [Flask Backend Repository](https://github.com/Nevish-302/flipkartFruits.git).

## Demo Video

[Watch our demonstration video here!]([https://link-to-your-demo-video.com](https://youtu.be/yyQb3SRsISA))

## Architecure(s)

![WhatsApp Image 2024-10-18 at 21 36 40](https://github.com/user-attachments/assets/d3375d08-ad6c-4623-aa37-e0488bed8078)

![WhatsApp Image 2024-10-18 at 21 36 40](https://github.com/user-attachments/assets/52c92560-775b-4d6f-abbb-2ce01663a1ce)


## User Interface Preview

![UI Screenshot](https://github.com/user-attachments/assets/8839029f-b2d6-48e1-925e-20efb2b0d5a6)

https://github.com/user-attachments/assets/f58533d3-e75d-4054-9dd1-6ab22bb774b6

https://github.com/user-attachments/assets/2788cb76-0aad-409d-863b-bc2e081c430e

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/nitish12rm/FlipkartGrid_Frontend
   cd flutter-fruit-shelf-life
   ```
2. **Install dependencies**:
```bash
flutter pub get
```

3. **Run the application**:
```bash
flutter run
```

## Contributing
Feel free to contribute by submitting issues or pull requests!

## License
This project is licensed under the MIT License.
