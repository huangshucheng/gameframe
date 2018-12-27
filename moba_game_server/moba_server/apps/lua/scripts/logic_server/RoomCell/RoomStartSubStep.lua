local Room = class('Room')

function Room:stop_step_start_game()
	print('Room:stop_step_start_game..........')
end

function Room:stop_step_ante()
	print('Room:stop_step_ante..........')
end

function Room:stop_step_specf_mah()
	print('Room:stop_step_specf_mah..........')
end

function Room:stop_step_throw_chip_1()
	print('Room:stop_step_throw_chip_1..........')
end

function Room:stop_step_throw_chip_2()
	print('Room:stop_step_throw_chip_2..........')
end

function Room:stop_step_take_first()
	print('Room:stop_step_take_first..........')
end

function Room:stop_step_throw_chip_3()
	print('Room:stop_step_throw_chip_3..........')
end

function Room:stop_step_open_mah()
	print('Room:stop_step_open_mah..........')
end

function Room:stop_step_first_replace()
	print('Room:stop_step_first_replace..........')
end

function Room:stop_step_play_mah()
	print('Room:stop_step_play_mah..........')
end

function Room:stop_step_win_lost()
	print('Room:stop_step_win_lost..........')
end

function Room:stop_step_end_game()
	print('Room:stop_step_end_game..........')
end

return Room