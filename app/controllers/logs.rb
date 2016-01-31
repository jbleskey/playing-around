get "/logs/new" do
  if logged_in?
    if council?
      @members = Member.all
      @members = @members.sort_by &:current_points
      @members.reverse!
      @bosses = Boss.all
      erb :"/new/log"
    else
      erb :index
    end
  else
    erb :login
  end
end

get '/logs' do
  if logged_in?
    @runs = Run.all
    @runs.to_a.sort! { |a,b| b.id <=> a.id }
    @parties = Party.all
    erb :logs
  else
    erb :login
  end
end

post '/logs' do
  if params[:names]
    boss = Boss.where(name: params[:boss]).first
    item = Item.create(name: params[:item])
    drop = Drop.create(item_id: item.id, point_cost: 0)
    run = Run.create(boss_id: boss.id, drop_id: drop.id, date: params[:date], time: params[:time])

    params[:names].each do |user|
      object = Member.where(username: user)
      id = object.first.id
      value = object.first.current_points
      Party.create(run_id: run.id, member_id: id)
      if object.first.daily_point_bonus
        Member.update(id, current_points: (100 + value), daily_point_bonus: false)
      else
        Member.update(id, current_points: (10 + value))
      end
    end
    redirect '/'
  else
    erb :error
  end
end

put "/logs" do
  run = Run.find(params[:id])
  Run.update(params[:id], date: params[:date], time: params[:time])
  run.boss.name = params[:boss]
  run.boss.save
  if (params[:item] != "")
    run.item.name = params[:item]
    run.item.save
  end
  if (params[:winner] != "")
    winner = Member.where(username: params[:winner].downcase)[0]
    if winner
      run.drop.winner_id = winner.id
      run.drop.save
    end
  end
  redirect "/logs"
end

get "/logs/edit/:id" do
  if params[:id]
    @run = Run.find(params[:id])
  end
  erb :"_edit-log", layout: false
end

