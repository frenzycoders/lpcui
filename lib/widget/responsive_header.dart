import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/widget/similar_header.dart';

class ResponsiveHeader extends StatelessWidget {
  ResponsiveHeader({
    Key? key,
    required this.headerText,
    required this.onLogoutTapped,
    required this.username,
    required this.onHeaderTapped,
    required this.onCreate,
  }) : super(key: key);
  String headerText;
  String username;
  Function onLogoutTapped;
  Function onHeaderTapped;
  Function onCreate;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 1200
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.15),
            child: SimilarHeader(
              onCreate: () {
                onCreate();
              },
              header: headerText,
              onTap: () {
                onLogoutTapped();
              },
              username: username,
              onrefresh: () {
                onHeaderTapped();
              },
            ),
          )
        : width > 720 && width < 1200
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SimilarHeader(
                  onCreate: () {
                    onCreate();
                  },
                  header: headerText,
                  onTap: () {
                    onLogoutTapped();
                  },
                  username: username,
                  onrefresh: () {
                    onHeaderTapped();
                  },
                ),
              )
            : Card(
                elevation: 2,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                child: Icon(Icons.person),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              Flexible(
                                child: Text(
                                  username,
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onLogoutTapped();
                          },
                          icon: Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
