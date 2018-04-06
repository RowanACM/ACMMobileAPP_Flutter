import 'dart:async';

import 'dart:convert';

import 'dart:io';

var base_url = 'https://api.rowanacm.org/prod/';

Future get(url)async {
        var result;
        var httpClient = new HttpClient();
        try {
          var request = await httpClient.getUrl(Uri.parse(url));
          var response = await request.close();
          if (response.statusCode == HttpStatus.OK) {
            var json = await response.transform(UTF8.decoder).join();
            var data = JSON.decode(json);
            result = data;
          } else {
            result =
            'Error in GET \nHttp status ${response.statusCode}';
          }
        } catch (exception) {
          result = 'Failed GET \n ${exception.toString()}';
        }
        print(result);
        return result;

}