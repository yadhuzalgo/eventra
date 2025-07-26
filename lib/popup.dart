import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class Popup extends StatelessWidget {
  final double radius;
  final String mdFilename;

  Popup({super.key, this.radius = 8, required this.mdFilename})
      : assert(mdFilename.contains('.md'), 'The file must contain .md extension');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(future: Future.delayed(Duration(microseconds: 150)).then((value)=>
                 rootBundle.loadString('assets/$mdFilename')),

                  builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Markdown(data: snapshot.data.toString(),);
                }
                return Center(child: CircularProgressIndicator(),);
              }),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius)
                  )
                ),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: Text('done',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
              )

            ),
          ],
        ),
      ),
    );
  }
}
