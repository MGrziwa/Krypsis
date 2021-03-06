/*
 * Krypsis - Write web applications based on proved technologies
 * like HTML, JavaScript, CSS... and access functionality of your
 * smartphone in a platform independent way.
 *
 * Copyright (C) 2008 - 2009 krypsis.org (have.a.go@krypsis.org)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

package org.krypsis.android.command.screen;

import android.view.OrientationEventListener;
import org.krypsis.android.Application;
import org.krypsis.command.Screens;
import org.krypsis.http.request.Requestable;
import org.krypsis.http.response.Response;
import org.krypsis.http.response.ResponseDispatchable;
import org.krypsis.http.response.SuccessResponse;
import org.krypsis.module.Module;
import org.krypsis.module.ModuleListener;

public class ScreenOrientationListener extends OrientationEventListener implements ModuleListener {
  private final Requestable request;
  private final ResponseDispatchable dispatchable;

  public ScreenOrientationListener(Application application, Requestable request, ResponseDispatchable dispatchable) {
    super(application);
    this.request = request;
    this.dispatchable = dispatchable;
  }

  public void onOrientationChanged(int i) {
    final Response response = new SuccessResponse(getRequest());
    if(i >= 90 && i <= 270) {
      i = 90;
    } else {
      i = 0;
    }
    response.setParameter(Screens.ORIENTATION, i);
    dispatchable.dispatch(response);
  }

  public void onDestroy(Module module) {
    disable();
  }

  public Requestable getRequest() {
    return request;
  }
}
