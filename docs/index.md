# COVID-19 INFO

_Project developed by Guilherme Alexandre dos Santos Johann_

The project was developed under Mobile Applications and Services course from the Software Engineering Master at Superior School of Technology, Polytechnic Institute of Setúbal (ESTS/IPS) during the 2020 year.

<div style="display: flex; flex-direction:column; justify-content: space-around; align-items: center;">
  <img src="https://github.com/gjohann7/covid_info/blob/master/docs/assets/logo-ESTS.png?raw=true" alt="IPS logo">
  <p><b>Figure:</b> IPS logo.</p>
</div>

## Application Goal and Who should use this App

The application goal is to provide people with updated information about COVID-19
status. It considers the whole world, as well as it does contemplate a country
perspective. Acknowledging its considerations, any user who holds an interest in
this subject may be pleased to use this app.

Therefore, the app affords the COVID-19's data visualization using charts to inform
and keep the user tuned about it. Yet, for those more concerned about the COVID-19
situation, the charts may provide insights to them.

## About technological choices

To develop the mobile app it was used Flutter. It is a Google's UI toolkit for crafting
beautiful, natively compiled applications for mobile, web, and desktop from a single
codebase. Therefore, the developed app can be used at least with either IOS and Android
devices.

With Flutter, the Visual Studio Code (VSCode) was chosen to integrate the development
tools. Also, in the VSCode, it was installed the Flutter extension (which can be found
[here](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)) to
complete the set up of the development environment. As a personal choice, a real device
was used to run the app.

## Application Architecture and Features

The project was divided into these five sections: (1) **Pages**, where the user interfaces (UI)
were designed; (2) **Logic aspect**, where the bridge between the app with the database controller
and the API were developed; (3) **Database**, where the database configurations were established;
(4) **Models**, where the models used in the app were defined; and (5) **Charts**, where all
used charts configurations and behaviors were set.

### Pages (UI)

The first section was touch to be easy of use and intuitive. Yet, there was no such
beautiful art to please the user. Also, in this section were done the instructions
to retrieve the device localization, and then the current country name.

The following illustrations present the app UI. The first one shows the introductory page of the app.
There are a welcome message, a brief app description and the data source. Below that, there is a bottom
navigation bar which uses tabs to change the screen.

<div style="display: flex; flex-direction:column; justify-content: space-around; align-items: center;">
  <img src="https://github.com/gjohann7/covid_info/blob/master/docs/assets/illustration1_introductory_screen.png?raw=true" alt="Introductory page of the app">
  <p><b>Illustration:</b> Introductory page of the app (June 27th, 2020).</p>
</div>

The second illustration shows a GIF presenting the global summary dashboard. This dashboard presents the
status totality of the COVID-19.

<div style="display: flex; flex-direction:column; justify-content: space-around; align-items: center;">
  <img src="https://github.com/gjohann7/covid_info/blob/master/docs/assets/illustration2_global_summary_dashboard.gif?raw=true" alt="Global Summary Dashboard">
  <p><b>Illustration:</b> Global Summary Dashboard (June 27th, 2020).</p>
</div>

The third and last illustration shows the second chart of the details section. It's an interactable timeline
series chart. It presents the behavior of the active cases between the first-day case to the last day
present in the API data.

<div style="display: flex; flex-direction:column; justify-content: space-around; align-items: center;">
  <img src="https://github.com/gjohann7/covid_info/blob/master/docs/assets/illustration3_active_cases_timeline_series_chart.png?raw=true" alt="Active Cases Timeline Series Chart">
  <p><b>Illustration:</b> Active Cases Timeline Series Chart (June 27th, 2020).</p>
</div>

### Logic Aspect

The second section is responsible for the app business role. This one can be defined
as the core section because it affects the UI and the database, as well as it is
responsible for effectively connect to the COVID-19 API.

> The API used can be found [here](https://covid19api.com/), and its documentation, [here](https://documenter.getpostman.com/view/10808728/SzS8rjbc?version=latest).

The logic flow complies to this process pattern:

1. Try to retrieve the data from the API;
2. If succeed, treat the response data and turn it into objects, and also save the data in the database;
3. Otherwise, throws an error:
   - In this case, the system tries to read the data requested to the API from the database:
     - If fails or there is no data stored, throws an error.
4. Return either an object with the data requested or an error.

### Database and Models

These sections describe the models of the business role and define how the system
can interact with the database. Even though it may seem strange, not all the models
are persisted.

The persisted models are the `global`, `country` and `all_status_by_country`. These three
models hold all the necessary data from the app. The other models support the logic of the
communication between the software layers. Among the support models, an important one is the
`chart_data` model. It provides a template from which all models can be rendered by the
charts.

### Charts

This last section abords all the design and behaviors of each chart. There were used the
pie, bar (the vertical and horizontal ones), line - as time series, and stacked area line
charts. In addition to the graphics being interactable, they also satisfy the data
visualization principles.

### Final Notes

With the use of the `chart_data` model, the system becomes much more scalable, because
it does implements a template to standardize the data from the general models.

The speed of the app also depends on the user Internet connection, thus, there are also
indications in the UI when the app is loading the data. After the data are retrieved, the
charts are fastly rendered. Yet, with the use of the database, if there was no connection
to the Internet at all, an out of date data will be used to render the visualizations, and
it also will be informed to the user too.

Finally, with the use of the described architecture, the app source code is highly adaptative,
understandable and modularized. Therefore, it is easy to manage and make improvements.

## What spoke who used this App

The app was installed in some devices for its owners to test/use the COVID-19 INFO app.
It was described to be intuitive, easy to use and to be direct to the point. Also,
there was noted that the app does not have many features besides its goal. Also, this
last observation pointed out the app interface as not polluted.

<br/>

> End of document.
