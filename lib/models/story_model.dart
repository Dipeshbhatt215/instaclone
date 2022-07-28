import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


enum MediaType { image, video }

class Story extends Equatable {
  final String url;
  final MediaType media;
  final Duration duration;
  final User user;

  const Story(
      {required this.url,
      required this.media,
      required this.duration,
      required this.user});

  Story copyWith({required String url, required MediaType media, required Duration duration,required User user}) {
    return new Story(
        url: url,
        media: media,
        duration: duration,
        user: user);
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [url, media, duration, user];
}