import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movieapp/bloc/get_persons_bloc.dart';
import 'package:movieapp/model/person.dart';
import 'package:movieapp/model/person_response.dart';
import '../style/theme.dart' as Style;

class PersonsList extends StatefulWidget {
  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  @override
  void initState() {
    super.initState();
    personsBloc..getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: 10,
            top: 20,
          ),
          child: Text(
            'TRANDING PERSONS OF THE WEEK',
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder<PersonResponse>(
          stream: personsBloc.subject.stream,
          builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildPersonWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 220,
            child: Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 4,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Error Occured:$error'),
        ],
      ),
    );
  }

  Widget _buildPersonWidget(PersonResponse data) {
    List<Person> persons = data.persons;
    return Container(
      height: 116,
      
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
        itemCount: persons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            padding: EdgeInsets.only(top: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                persons[index].profileImg == null
                    ? Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Style.Colors.secondColor,
                        ),
                        child: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/w200/" +
                                      persons[index].profileImg),fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(persons[index].name,maxLines: 2,style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),),
                      SizedBox(
                        height: 3,
                      ),
                      Text("Trending For ${persons[index].known}",style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 8,
                        color: Style.Colors.titleColor,
                      ),)
              ],
            ),
          );
        },
      ),
    );
  }
}
