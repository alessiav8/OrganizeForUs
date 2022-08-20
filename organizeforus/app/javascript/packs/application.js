
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require("trix")
require("@rails/actiontext")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import 'css/application';

import $ from 'jquery';
global.$ = jQuery;

import "bootstrap";

import moment from 'moment'
window.moment = moment
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";


document.addEventListener('turbolinks:load', function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new Calendar(calendarEl, {
    events: '/events.json',
    plugins: [ dayGridPlugin ]
  });
  calendar.render();
});