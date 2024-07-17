import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'globals.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final myBox=Hive.box("Chatbox");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: botMessagesList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(timeAndDate[index],style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.1),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.person,color: Colors.blueGrey,size: 30,),
                        title: Text(
                          userMessagesList[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(25))
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: const AssetImage("images/google.png"),
                          backgroundColor: Colors.grey.withOpacity(.1),
                        ),
                        title: Text(
                          botMessagesList[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,)
                  ],
                );
              },
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                timeAndDate.clear();
                userMessagesList.clear();
                botMessagesList.clear();

                myBox.put(1, userMessagesList);
                myBox.put(2, botMessagesList);
                myBox.put(3, timeAndDate);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 100,vertical: 10),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: const Center(
                child: Text(
                  "Clear History",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
