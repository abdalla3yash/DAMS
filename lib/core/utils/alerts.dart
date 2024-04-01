
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void Toaster(String message) => Toast.show(message, duration: Toast.lengthLong, gravity: Toast.bottom);


void Alerts(context,String message)=> ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Permission to access $message denied. Please enable it manually in settings.'),
    ),
  );