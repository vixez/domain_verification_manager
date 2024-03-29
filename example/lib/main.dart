import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:domain_verification_manager/domain_verification_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AfterLayoutMixin<MyApp> {
  String _isSupported = 'Unknown';
  String _domainStateVerified = 'Unknown';
  String _domainStateSelected = 'Unknown';
  String _domainStateNone = 'Unknown';

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (await getIsSupported()) {
      getDomainStageVerified();
      getDomainStateSelected();
      getDomainStateNone();
    }
  }

  Future<bool> getIsSupported() async {
    String result;
    bool _supported = false;
    try {
      _supported = await DomainVerificationManager.isSupported;
      result = _supported.toString();
    } on PlatformException {
      result = 'Failed to get getIsSupported';
    }
    if (!mounted) {
      _isSupported = result;
      return _supported;
    }

    setState(() {
      _isSupported = result;
    });

    return _supported;
  }

  Future<void> getDomainStageVerified() async {
    String result;
    try {
      result = (await DomainVerificationManager.domainStageVerified).toString();
    } on PlatformException {
      result = 'Failed to get domainStageVerified';
    }
    if (!mounted) {
      _domainStateVerified = result;
      return;
    }

    setState(() {
      _domainStateVerified = result;
    });
  }

  Future<void> getDomainStateSelected() async {
    String result;
    try {
      result = (await DomainVerificationManager.domainStageSelected).toString();
    } on PlatformException {
      result = 'Failed to get domainStageSelected';
    }
    if (!mounted) {
      _domainStateSelected = result;
      return;
    }

    setState(() {
      _domainStateSelected = result;
    });
  }

  Future<void> getDomainStateNone() async {
    String result;
    try {
      result = (await DomainVerificationManager.domainStageNone).toString();
    } on PlatformException {
      result = 'Failed to get domainStageNone';
    }
    if (!mounted) {
      _domainStateNone = result;
      return;
    }

    setState(() {
      _domainStateNone = result;
    });
  }

  Future<void> domainRequest() async {
    await DomainVerificationManager.domainRequest();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Domain Veriification Manager'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Supported: $_isSupported\n\n',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Verified:\n$_domainStateVerified\n\n',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Not verified, but user associated the link:\n$_domainStateSelected\n\n',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Not verified and not assiociated to the app:\n$_domainStateNone\n\n',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: domainRequest,
                  child: const Text('Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
