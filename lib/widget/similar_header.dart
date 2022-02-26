import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SimilarHeader extends StatelessWidget {
  SimilarHeader({
    Key? key,
    required this.header,
    required this.onTap,
    required this.username,
    required this.onrefresh,
    required this.onCreate,
  }) : super(key: key);
  String header;
  String username;
  Function onTap;
  Function onrefresh;
  Function onCreate;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  onrefresh();
                },
                child: Text(
                  header,
                  style: GoogleFonts.firaSans(
                    fontWeight: FontWeight.w400,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      onCreate();
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SizedBox(
                      width: 150,
                      child: Card(
                        color: Colors.black12,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.person),
                              ),
                              Flexible(
                                child: Text(
                                  username,
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onTap();
                    },
                    icon: Icon(Icons.logout, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
