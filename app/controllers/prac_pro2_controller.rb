require 'prac_pro2'

class PracPro2Controller < InformaticaController
  
  def index
    @body = render_to_string('prac_pro2/0', layout: false)
  end
  
  def file
    respond_json params[:id].to_i
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
  
protected

  def respond_json(id)
    if id >= 0 && id <= 12
      body = render_to_string("prac_pro2/#{id}", layout: false)
      render :json => { body: body }
    else
      render :json => { message: "A tomar por culo!" }, status: 404
    end
  end

end
