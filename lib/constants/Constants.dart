
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:list_todo/views/homePage.dart';
import 'package:list_todo/views/introductionPage.dart';

// Routes
const String homeRoute = 'home';
const String introductionRoute = 'introduction';

const Color background = Colors.white;
const Color primaryColor = Color.fromRGBO(94, 61, 164, 1);
const Color warningColor = Color.fromRGBO(236, 182, 27, 1);
final Color doneTodo = Colors.green;
final Color deactiveColor = Colors.grey[300];

GetStorage box = GetStorage();



var pages = [
  GetPage(name: homeRoute, page: () => homePage()),
  GetPage(name: introductionRoute, page:() => OnBoardingPage())
];