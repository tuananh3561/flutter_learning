import 'package:flutter/material.dart';
import 'package:ninja_id/quote.dart';

void main() {
  runApp(MaterialApp(
    home: QuoteList(),
  ));
}

class QuoteList extends StatefulWidget {
  const QuoteList({Key? key}) : super(key: key);

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quote> quotes = [
    Quote(text: "this is the qite  text", author: "oscar wilde"),
    Quote(text: "this is the qite  text", author: "oscar wilde"),
    Quote(text: "this is the qite  text", author: "oscar wilde"),
    Quote(text: "this is the qite  text", author: "oscar wilde"),
  ];

  Widget quoteTemplate(Quote quote) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(quote.text, style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),),
            SizedBox(height: 6.0,),
            Text(quote.author, style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Awesome Quotes"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: quotes.map((quote) => quoteTemplate(quote)).toList(),
      ),
    );
  }
}
