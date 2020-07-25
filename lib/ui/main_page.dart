import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../ui/post_item.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController controller = ScrollController();
  PostBloc bloc;

  void onScroll(){
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if(currentScroll == maxScroll){
      bloc.add(PostEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PostBloc>(context);
    controller.addListener(onScroll);

    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite List With BLoC'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostUnintialized)
              return Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              );
            else {
              PostLoaded postLoaded = state as PostLoaded;
              return ListView.builder(
                controller: controller,
                itemCount: (postLoaded.hasReachedMax)
                    ? postLoaded.posts.length
                    : postLoaded.posts.length + 1,
                itemBuilder: (ctx, i) => (i < postLoaded.posts.length)
                    ? PostItem(postLoaded.posts[i])
                    : Container(
                      child: Center(
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          ),
                      ),
                    ),
              );
            }
          },
        ),
      ),
    );
  }
}
