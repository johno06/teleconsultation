import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teleconsultation/starting_page/register.dart';


class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);


  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late bool accept;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // var po = context.read<RegisterScreen>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.012),
              SizedBox(
                width: size.width,
                // margin: EdgeInsets.symmetric(horizontal: size.width * 0.35),
                child: Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: size.height * 0.075,
                      color: Colors.redAccent,
                    ),
                    SizedBox(
                        width: size.width * 0.04,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Terms of Services",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            fontSize: size.height * 0.024,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withOpacity(0.85),
                          ),
                        ),
                        Text(
                          "Last Updated: March 03, 2022",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                            fontSize: size.height * 0.0175,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Expanded(
                  child:Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(
                              //   // height: size.height * 0.04,
                              // ),
                              Text(
                                "1. Terms and Conditions",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: size.height * 0.020,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.85),
                                ),
                              ),
                              Text(
                                "Paragraphs are the building blocks of papers. Many students define paragraphs in terms of length: a paragraph is a group of at least five sentences, a paragraph is half a page long, etc. In reality, though, the unity and coherence of ideas among sentences is what constitutes a paragraph. A paragraph is defined as “a group of sentences or a single sentence that forms a unit” (Lunsford and Connors 116). Length and appearance do not determine whether a section in a paper is a paragraph. For instance, in some styles of writing, particularly journalistic styles, a paragraph can be just one sentence long. Ultimately, a paragraph is a sentence or group of sentences that support one main idea. In this handout, we will refer to this as the “controlling idea,” because it controls what happens in the rest of the paragraph.",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: size.height * 0.0175,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                "2. Privacy",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: size.height * 0.020,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.85),
                                ),
                              ),
                              Text(
                                "Paragraphs are the building blocks of papers. Many students define paragraphs in terms of length: a paragraph is a group of at least five sentences, a paragraph is half a page long, etc. In reality, though, the unity and coherence of ideas among sentences is what constitutes a paragraph. A paragraph is defined as “a group of sentences or a single sentence that forms a unit” (Lunsford and Connors 116). Length and appearance do not determine whether a section in a paper is a paragraph. For instance, in some styles of writing, particularly journalistic styles, a paragraph can be just one sentence long. Ultimately, a paragraph is a sentence or group of sentences that support one main idea. In this handout, we will refer to this as the “controlling idea,” because it controls what happens in the rest of the paragraph.",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: size.height * 0.0175,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                "3. Policy",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: size.height * 0.020,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.85),
                                ),
                              ),
                              Text(
                                "Paragraphs are the building blocks of papers. Many students define paragraphs in terms of length: a paragraph is a group of at least five sentences, a paragraph is half a page long, etc. In reality, though, the unity and coherence of ideas among sentences is what constitutes a paragraph. A paragraph is defined as “a group of sentences or a single sentence that forms a unit” (Lunsford and Connors 116). Length and appearance do not determine whether a section in a paper is a paragraph. For instance, in some styles of writing, particularly journalistic styles, a paragraph can be just one sentence long. Ultimately, a paragraph is a sentence or group of sentences that support one main idea. In this handout, we will refer to this as the “controlling idea,” because it controls what happens in the rest of the paragraph.",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: size.height * 0.0175,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
              SizedBox(height: size.height * 0.015),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.035),
                child: Row(
                  children: [
                    Expanded(
                      child: TermsButton(
                        title: "Decline",
                        onTap: (){
                          bool accept = false;
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(accept:accept)));
                          Navigator.pop(context, accept);
                        },
                      ),
                    ),
                    SizedBox(width: size.width * 0.025),
                    Expanded(
                      child: TermsButton(
                        isAccepted: true,
                        title: "Accept",
                        onTap: (){
                          bool accept = true;
                          // accept = true;
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(accept:accept)));
                          Navigator.pop(context, accept);
                          // print("$isAccepted");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermsButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isAccepted;
  const TermsButton({Key? key, required this.title, required this.onTap, this.isAccepted = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap(),
      // splashColor: Colors.black.withOpacity(0.15),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.012,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFf07590),
            width: size.width * 0.005,
          ),
          borderRadius: BorderRadius.circular(size.height * 0.01),
          color: isAccepted ? const Color(0xFFf07590) : Colors.white,
        ),
        child: Text(
            title,
            textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: size.height * 0.022,
            fontWeight: FontWeight.w600,
            color: isAccepted ? Colors.white : Colors.redAccent,
          ),
        ),
      ),
    );
  }
}

