<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Simple Paypal SDK for Flutter.

## Usage

This package provides three main [Features](#features). In order to handle payment you must need to have [webview_flutter](https://pub.dev/packages/webview_flutter).

You can check in the `/example` folder.

```dart
import 'package:flutter_paypal_sdk/flutter_paypal_sdk.dart';
```

## Features

- [Authentication](#authentication)
- [Create Payment](#create-payment)
- [Execute Payment](#execute-payment)

---

## Initiate FlutterPaypalSDK

```dart
FlutterPaypalSDK sdk = FlutterPaypalSDK(
  clientId:'yourClientId',
  clientSecret: 'yourSecretId',
  mode: Mode.sandbox, // this will use sandbox environment
);
```

## Authentication

```dart
AccessToken accessToken = await sdk.getAccessToken();
```

## Create Payment

```dart
Payment payment = await sdk.createPayment(
  transactions,
  accessToken.token!,
);
```

Please refer to [PayPal Payment API](https://developer.paypal.com/docs/archive/payments/paypal-payments/#set-up-your-development-environment) for more detail on required params and payment response.

## Execute Payment

```dart
Payment payment = await sdk.executePayment(
  executeUrl,
  payerId,
  accessToken,
);
```
