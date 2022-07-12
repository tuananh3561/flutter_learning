import 'package:flutter/material.dart';
import 'package:ninja_id/quote.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;
  final VoidCallback delete;

  const QuoteCard({Key? key, required this.quote, required this.delete})
      : super(key: key);

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.quote.text,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                widget.quote.author,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8.0),
              FlatButton.icon(
                onPressed: widget.delete,
                label: Text('delete quote'),
                icon: Icon(Icons.delete),
              )
            ],
          ),
        ));
  }
}
