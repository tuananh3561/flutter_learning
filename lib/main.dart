import 'package:flutter/material.dart';
import 'package:ninja_id/quote.dart';
import 'package:ninja_id/quote_card.dart';

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
        children: quotes.map((quote) => QuoteCard(quote: quote)).toList(),
      ),
    );
  }
}
