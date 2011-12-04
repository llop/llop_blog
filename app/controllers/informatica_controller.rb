require 'prac_pro2'

class InformaticaController < ApplicationController
  
  def index    
    session[:rs] = [ 'proyectos' ]
    session[:pr] = 'proyectos'
    @nav = routes_tag('proyectos', session[:rs])
    @proyectos = render_to_string('informatica/proyectos', layout: false)
  end
  
  def proyecto
    respond_json 'informatica/'
  end
  
  def practica_pro2
    respond_json 'prac_pro2/'
  end
  
  def jp_tester
    data = params[:jp_data]
    begin
      result = Practica.new.metod data
      render :json => { result: result }
    rescue
      render :json => { message: "Juego de pruebas chungo!!!" }, status: 500
    end
  end
  
private

  PROYECTO_ROUTES = [ 'proyectos', 'prac_pro2' ]
  PRAC_PRO2_ROUTES = [ 'main', 'jp_tester', 'red', 'cjt_coch', 'cjt_tren', 'leer_red', 'leer_red_rec', 'leer_cjt_coch', 'leer_coch', 'leer_cjt_tren', 'leer_tren_coch',
    'leer_tren', 'set_tren', 'get_id', 'get_vagones', 'set_vagones', 'escribe_cjt_coch', 'escribe_coch', 'escribe_coch_rec', 'for_mat', 'tren_for_mat',
    'get_tren', 'vacia_coch', 'mov', 'escribe_mov_coch', 'escribe_mov', 'anade_vagon_pila', 'saca_vagon', 'mov_via_via', 'mov_via_muerta', 'mov_via_aux',
    'anade_mov', 'cuenta_mov', 'alm_noc', 'tren_alm_noc', 'set_salida', 'set_tiempo', 'get_tiempo_rec', 'get_salida', 'get_tiempo', 'sort', 'escribe_llegada',
    'format', 'llena_coch', 'anade_vagon_vec', 'get_libre' ]
  
  def respond_json(template_folder)
    route = params[:r]
    if valid_route? route
      routes = make_routes route
      session[:pr] = route
      routes_str = routes_tag(route, routes)
      body = render_to_string(template_folder + route, layout: false)
      render :json => { routes: routes_str, body: body }
    else
      render :json => { message: "Uh-uh, try again!" }, status: 404
    end
  end
  
  def make_routes(route)
    unless session[:rs].include? route
      routes = session[:rs].take_while { |r| r != session[:pr] }
      routes << session[:pr]
      session[:rs] = (routes << route)
    end
    session[:rs]
  end
  
  def all_routes
    @@routes ||= (PROYECTO_ROUTES + PRAC_PRO2_ROUTES)
  end
  
  def valid_route?(route)
    all_routes.include? route
  end
  
  def routes_tag(current_route, routes)
    js = ""
    html = ""
    is_first = true
    routes.each do |route|
      route_lnk = route + '_lnk'
      js += current_route == route ? '' : ('ajaxify("#' + route_lnk + '"); ')
      html += is_first ? '' : ' &gt; '
      html += current_route == route ? route : self.class.helpers.link_to(route, get_route_path(route), remote: true, id: route_lnk, :'data-type' => :json)
      is_first = false if is_first
    end
    js = '<script type="text/javascript" language="javascript">$(document).ready(function() { ' + js + '});</script>'
    html = '<div>' + html + '</div>'
    js + html
  end
  
  def get_route_path(route)
    if PROYECTO_ROUTES.include? route
      proyecto_path(:r => route)
    elsif PRAC_PRO2_ROUTES.include? route
      practica_pro2_path(:r => route)
    end
  end
  
end