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

package org.krypsis.blackberry.command.screen;

import org.krypsis.module.Command;
import org.krypsis.module.Module;
import org.krypsis.http.request.Requestable;
import org.krypsis.http.response.ResponseDispatchable;
import org.krypsis.http.response.Response;
import org.krypsis.http.response.SuccessResponse;
import org.krypsis.log.LoggerFactory;
import org.krypsis.log.Logger;
import org.krypsis.command.Screens;
import net.rim.device.api.system.Display;

/**
 * Date: 13.05.2009
 */
public class GetScreenInfoCommand implements Command {
  private Logger logger = LoggerFactory.getLogger(GetScreenInfoCommand.class);

  public void execute(Module module, Requestable request, ResponseDispatchable dispatchable) {
    final Response response = new SuccessResponse(request);
    final int height = Display.getHeight();
    final int width = Display.getWidth();

    response.setParameter(Screens.WIDTH, new Integer(width));
    response.setParameter(Screens.HEIGHT, new Integer(height));

    final int orientation = Display.getOrientation();
    switch (orientation) {
      case Display.ORIENTATION_LANDSCAPE:
        response.setParameter(Screens.ORIENTATION, new Integer(90));
        break;
      case Display.ORIENTATION_PORTRAIT:
        response.setParameter(Screens.ORIENTATION, new Integer(0));
        break;
      default:
        response.setParameter(Screens.ORIENTATION, new Integer(0));
    }
    logger.info("Return screen info");

    dispatchable.dispatch(response);
  }
}
